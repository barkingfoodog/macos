# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-macos1010"
    config.vm.box = "macos1010"
 
    ["vmware_fusion", "vmware_workstation"].each do |provider|
        config.vm.provider provider do |v, override|
            v.gui = true
            v.vmx["memsize"] = "2048"
            v.vmx["numvcpus"] = "1"
            v.vmx["firmware"] = "efi"
            v.vmx["keyboardAndMouseProfile"] = "macProfile"
            v.vmx["smc.present"] = "TRUE"
            v.vmx["hpet0.present"] = "TRUE"
            v.vmx["ich7m.present"] = "TRUE"
            v.vmx["ehci.present"] = "TRUE"
            v.vmx["usb.present"] = "TRUE"
            v.vmx["scsi0.virtualDev"] = "lsilogic"
        end
    end

    config.vm.provider :virtualbox do |v, override|
      v.gui = true
      v.customize ["modifyvm", :id, "--audiocontroller", "hda"]
      v.customize ["modifyvm", :id, "--boot1", "dvd"]
      v.customize ["modifyvm", :id, "--boot2", "disk"]
      v.customize ["modifyvm", :id, "--chipset", "ich9"]
      v.customize ["modifyvm", :id, "--firmware", "efi"]
      v.customize ["modifyvm", :id, "--hpet", "on"]
      v.customize ["modifyvm", :id, "--keyboard", "usb"]
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--mouse", "usbtablet"]
      v.customize ["modifyvm", :id, "--vram", "128"]
      v.customize ["modifyvm", :id, "--audio", "none" ]
      v.customize ["modifyvm", :id, "--cpuidset", "00000001", "000106e5", "06100800", "0098e3fd", "bfebfbff" ]

      config.trigger.before :destroy do
        id_file = ".vagrant/machines/default/virtualbox/id"
        machine_id = File.read(id_file) if File.exist?(id_file)
        if !machine_id.nil?
          pid = `ps -ax | grep #{machine_id} | grep -v grep | cut -d ' ' -f 1`
          if pid =~ /\d+/
            info "Killing #{machine_id} with pid #{pid}"
            run "kill -9 #{pid}"
          end
        end
      end
    end

    config.vm.provider :parallels do |v, override|
      v.customize ["set", :id, "--memsize", "2048"]
      v.customize ["set", :id, "--memquota", "512:2048"]
      v.customize ["set", :id, "--cpus", "2"]
      v.customize ["set", :id, "--distribution", "macosx"]
      v.customize ["set", :id, "--3d-accelerate", "highest"]
      v.customize ["set", :id, "--high-resolution", "off"]
      v.customize ["set", :id, "--auto-share-camera", "off"]
      v.customize ["set", :id, "--auto-share-bluetooth", "off"]
      v.customize ["set", :id, "--on-window-close", "keep-running"]
      v.customize ["set", :id, "--isolate-vm", "off"]
      v.customize ["set", :id, "--shf-host", "off"]
    end
end
