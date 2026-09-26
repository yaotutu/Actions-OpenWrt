'use strict';
'require view';
'require fs';
'require ui';

function parseRelease(content) {
	var config = {};

	String(content || '').split(/\n/).forEach(function(line) {
		var match = line.match(/^([A-Z][A-Z0-9_]*)=(.*)$/);
		if (match)
			config[match[1]] = match[2];
	});

	return config;
}

function commandOutput(result) {
	return String(result.stdout || result.stderr || '').trim();
}

function setCurrentStatus(node, text, isError) {
	node.textContent = text || '';
	node.className = isError ? 'alert-message warning' : 'alert-message info';
}

return view.extend({
	load: function() {
		return L.resolveDefault(fs.read('/etc/gl-mt3000-release'), '');
	},

	setBusy: function(busy) {
		document.querySelectorAll('[data-update-action]').forEach(function(button) {
			button.disabled = !!busy;
			button.classList.toggle('spinning', !!busy);
		});
	},

	runUpdater: function(command, useForce, busyText, statusNode) {
		var args = [ command ];
		if (useForce)
			args.push('--force');

		this.setBusy(true);
		setCurrentStatus(statusNode, busyText, false);
		ui.showModal(busyText, [
			E('p', { 'class': 'spinning' }, [ busyText ])
		]);

		return fs.exec('/usr/sbin/gl-mt3000-update', args).then(L.bind(function(result) {
			ui.hideModal();

			if (result.code != 0) {
				setCurrentStatus(statusNode, commandOutput(result) || '更新命令执行失败。', true);
				return;
			}

			var output = commandOutput(result);
			setCurrentStatus(statusNode, output || '命令已执行。', false);

			if (command == 'upgrade') {
				ui.showModal('正在等待路由器重启', [
					E('p', { 'class': 'spinning' }, [ '路由器正在升级并重启，请不要断开电源。' ])
				]);
				return ui.awaitReconnect(window.location.host, '192.168.55.1', 'openwrt.lan').then(L.bind(function() {
					ui.hideModal();
					window.location.reload();
				}, this));
			}

			return output;
		}, this)).catch(L.bind(function(error) {
			if (command == 'upgrade') {
				// The HTTP request can be interrupted when sysupgrade stops uhttpd.
				// Treat it as the normal start of the reboot sequence.
				ui.showModal('正在等待路由器重启', [
					E('p', { 'class': 'spinning' }, [ '路由器正在升级并重启，请不要断开电源。' ])
				]);
				return ui.awaitReconnect(window.location.host, '192.168.55.1', 'openwrt.lan').then(L.bind(function() {
					ui.hideModal();
					window.location.reload();
				}, this)).catch(L.bind(function() {
					ui.hideModal();
					setCurrentStatus(statusNode, '升级请求已发出，但路由器尚未恢复连接。请稍后手动刷新页面。', true);
				}, this));
			}

			ui.hideModal();
			setCurrentStatus(statusNode, error.message || '更新命令执行失败。', true);
		}, this)).finally(L.bind(function() {
			this.setBusy(false);
		}, this));
	},

	handleCheck: function(statusNode, forceInput, ev) {
		return this.runUpdater('check', forceInput.checked, '正在查询本仓库最新 Release...', statusNode);
	},

	handleDownload: function(statusNode, forceInput, ev) {
		return this.runUpdater('download', forceInput.checked, '正在下载并校验固件...', statusNode);
	},

	handleUpgrade: function(statusNode, forceInput, ev) {
		if (!confirm('确定要现在下载并升级固件吗？升级过程中请不要断开电源。'))
			return Promise.resolve();

		return this.runUpdater('upgrade', forceInput.checked, '正在下载、校验并升级固件...', statusNode);
	},

	render: function(releaseContent) {
		var release = parseRelease(releaseContent);
		var currentTag = release.BUILD_TAG || 'unknown';
		var openwrtVersion = release.OPENWRT_VERSION || 'unknown';
		var statusNode = E('div', { 'class': 'alert-message info' }, [ '尚未查询最新版本。' ]);
		var forceInput = E('input', { type: 'checkbox' });

		return E('div', { 'class': 'cbi-map' }, [
			E('h2', {}, [ 'GL-MT3000 在线更新' ]),
			E('p', {}, [ '此页面只检测本仓库（yaotutu/gl-mt3000-openwrt）的 GitHub Releases，不会使用 OpenWrt 官方升级源。' ]),
			E('div', { 'class': 'cbi-section' }, [
				E('div', { 'class': 'cbi-value' }, [
					E('div', { 'class': 'cbi-value-title' }, [ '当前构建' ]),
					E('div', { 'class': 'cbi-value-field' }, [ currentTag ])
				]),
				E('div', { 'class': 'cbi-value' }, [
					E('div', { 'class': 'cbi-value-title' }, [ 'OpenWrt 基线' ]),
					E('div', { 'class': 'cbi-value-field' }, [ openwrtVersion ])
				]),
				E('div', { 'class': 'cbi-value' }, [
					E('div', { 'class': 'cbi-value-title' }, [ '更新源' ]),
					E('div', { 'class': 'cbi-value-field' }, [ 'yaotutu/gl-mt3000-openwrt' ])
				])
			]),
			E('div', { 'class': 'cbi-section' }, [
				E('div', { 'class': 'cbi-value' }, [
					E('div', { 'class': 'cbi-value-title' }, [ '强制同版本' ]),
					E('div', { 'class': 'cbi-value-field' }, [
						forceInput,
						' 查询和刷写时忽略“当前已经是最新版本”的判断'
					])
				])
			]),
			E('div', { 'class': 'right' }, [
				E('button', {
					'class': 'btn cbi-button-action important',
					'data-update-action': '',
					'click': ui.createHandlerFn(this, 'handleCheck', statusNode, forceInput)
				}, [ '检查更新' ]), ' ',
				E('button', {
					'class': 'btn cbi-button-action',
					'data-update-action': '',
					'click': ui.createHandlerFn(this, 'handleDownload', statusNode, forceInput)
				}, [ '下载并校验' ]), ' ',
				E('button', {
					'class': 'btn cbi-button-remove important',
					'data-update-action': '',
					'click': ui.createHandlerFn(this, 'handleUpgrade', statusNode, forceInput)
				}, [ '立即升级' ])
			]),
			E('div', { 'style': 'margin-top:1em' }, [ statusNode ])
		]);
	},

	handleSave: null,
	handleSaveApply: null,
	handleReset: null
});
