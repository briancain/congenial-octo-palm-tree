require 'childprocess'

command_options = ["vagrant@127.0.0.1",
   "-p",
   "2222",
   "-o",
   "Compression=yes",
   "-o",
   "DSAAuthentication=yes",
   "-o",
   "LogLevel=FATAL",
   "-o",
   "IdentitiesOnly=yes",
   "-o",
   "StrictHostKeyChecking=no",
   "-o",
   "UserKnownHostsFile=/dev/null",
   "-i",
   "/Users/brian/code/vagrant-sandbox/.vagrant/machines/default/virtualbox/private_key",
   "-t",
   "bash -l -c 'echo test'"]

process = ChildProcess.build("ssh", *command_options)
process.io.inherit!

process.start
process.wait
