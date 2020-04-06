# To sync over Vagrantfile changes....

Run the following command _each_ time you wish to update the Vagrant source on the guest

```
vagrant provision --provision-with "Vagrant Sync" 
```

It will first run a trigger that builds the vagrant gem, and then the provisioner will
run which unpacks the gem onto the guest, and moves the updated source into place
