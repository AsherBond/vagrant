package myplugin

import (
	"github.com/hashicorp/vagrant-plugin-sdk/component"
	plugincore "github.com/hashicorp/vagrant-plugin-sdk/core"
)

type DummyConfig struct {
}

// DummyCommunicator is a Communicator implementation for myplugin.
type DummyCommunicator struct {
	config DummyConfig
}

func (h *DummyCommunicator) MatchFunc() interface{} {
	return h.Match
}

func (h *DummyCommunicator) Match(machine plugincore.Machine) (isMatch bool, err error) {
	return true, nil
}

func (h *DummyCommunicator) InitFunc() interface{} {
	return h.Init
}

func (h *DummyCommunicator) Init(machine plugincore.Machine) error {
	return nil
}

func (h *DummyCommunicator) ReadyFunc() interface{} {
	return h.Ready
}

func (h *DummyCommunicator) Ready(machine plugincore.Machine) (isReady bool, err error) {
	return false, nil
}

func (h *DummyCommunicator) WaitForReadyFunc() interface{} {
	return h.WaitForReady
}

func (h *DummyCommunicator) WaitForReady(machine plugincore.Machine, wait int) (isReady bool, err error) {
	return false, nil
}

func (h *DummyCommunicator) DownloadFunc() interface{} {
	return h.Download
}

func (h *DummyCommunicator) Download(
	machine plugincore.Machine,
	source, destination string,
) error {
	return nil
}

func (h *DummyCommunicator) UploadFunc() interface{} {
	return h.Upload
}

func (h *DummyCommunicator) Upload(
	machine plugincore.Machine,
	source, destination string,
) error {
	return nil
}

func (h *DummyCommunicator) ExecuteFunc() interface{} {
	return h.Execute
}

func (h *DummyCommunicator) Execute(
	machine plugincore.Machine,
	command []string,
	options ...CommunicatorOptions,
) (status int32, err error) {
	return 0, nil
}

func (h *DummyCommunicator) PrivilegedExecuteFunc() interface{} {
	return h.PrivilegedExecute
}

func (h *DummyCommunicator) PrivilegedExecute(
	machine plugincore.Machine,
	command []string,
	options ...CommunicatorOptions,
) (status int32, err error) {
	return 0, nil
}

func (h *DummyCommunicator) TestFunc() interface{} {
	return h.Test
}

func (h *DummyCommunicator) Test(
	machine plugincore.Machine,
	command []string,
	options ...CommunicatorOptions,
) (valid bool, err error) {
	return true, nil
}

func (h *DummyCommunicator) ResetFunc() interface{} {
	return h.Reset
}

func (h *DummyCommunicator) Reset(machine plugincore.Machine) (err error) {
	return nil
}

var (
	_ component.Communicator = (*DummyCommunicator)(nil)
)