package main

import (
	"github.com/hashicorp/go-plugin"
	"github.com/hashicorp/vagrant/ext/go-plugin/vagrant"
	vagrantplugin "github.com/hashicorp/vagrant/ext/go-plugin/vagrant/plugin"
)

type MyProvider struct {
	vagrantplugin.Core
	vagrant.NoGuestCapabilities
	vagrant.NoHostCapabilities
	vagrant.NoProviderCapabilities
}

func (c MyProvider) ConfigAttributes() (attrs []string, err error) {
	attrs = []string{"fubar", "foobar"}
	return
}

func (c MyProvider) ConfigLoad(data map[string]interface{}) (loaddata map[string]interface{}, err error) {
	return
}

func (c MyProvider) ConfigValidate(data map[string]interface{}, m *vagrant.Machine) (errors []string, err error) {
	return
}

func (c MyProvider) ConfigFinalize(data map[string]interface{}) (finaldata map[string]interface{}, err error) {
	finaldata = make(map[string]interface{})
	for key, tval := range data {
		val := tval.(string)
		finaldata[key] = val + "-updated"
	}
	return
}

func (c MyProvider) Action(actionName string, m *vagrant.Machine) ([]string, error) {
	return []string{}, nil
}

func (c MyProvider) Capability(capName string, args []string, m *vagrant.Machine) (string, error) {
	return "", nil
}

func (c MyProvider) HasCapability(capName string, m *vagrant.Machine) (bool, error) {
	return false, nil
}

func (c MyProvider) IsInstalled(m *vagrant.Machine) (bool, error) {
	m.UI.Say("I'm saying some words from the plugin to STDOUT!!!!! \\o/")
	m.UI.Error("Is this colored at all??????")
	foobar := m.ProviderConfig["foobar"].(string)
	m.UI.Say("My foobar value is: " + foobar)
	return true, nil
}

func (c MyProvider) IsUsable(m *vagrant.Machine) (bool, error) {
	return false, nil
}

func (c MyProvider) MachineIdChanged(m *vagrant.Machine) error {
	return nil
}

func (c MyProvider) Name() string {
	return "test_desktop"
}

func (c MyProvider) RunAction(actionName string, data string, m *vagrant.Machine) (string, error) {
	return "", nil
}

func (c MyProvider) SshInfo(m *vagrant.Machine) (*vagrant.SshInfo, error) {
	return &vagrant.SshInfo{}, nil
}

func (c MyProvider) State(m *vagrant.Machine) (*vagrant.MachineState, error) {
	m.UI.Say("I'm saying some words from the plugin to STDOUT!!!!! \\o/")
	m.UI.Error("Is this colored at all --- ?")
	foobar := m.ProviderConfig["foobar"].(string)
	m.UI.Say("My foobar value is: " + foobar)

	vm := m.Config["vm"].(map[string]interface{})
	box := vm["box"].(string)
	println("testing machine config access. currently configured box: " + box)
	return &vagrant.MachineState{Id: "default", ShortDesc: "running", LongDesc: "Really Running!"}, nil
}

func (c MyProvider) Info() *vagrant.ProviderInfo {
	return &vagrant.ProviderInfo{
		Description: "My custom provider",
		Priority:    10}
}

func main() {
	plugin.Serve(&plugin.ServeConfig{
		HandshakeConfig: plugin.HandshakeConfig{
			ProtocolVersion:  1,
			MagicCookieKey:   "BASIC_PLUGIN",
			MagicCookieValue: "hello",
		},
		VersionedPlugins: map[int]plugin.PluginSet{
			2: {
				"provider": &vagrantplugin.GRPCProviderPlugin{
					Impl: &MyProvider{},
				},
			},
		},
		GRPCServer: plugin.DefaultGRPCServer,
	})
}
