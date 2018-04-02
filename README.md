# powershell-shell


Interactive reverse and bind powershell based shell.

Using this powershell script, reverse or bind shell can be created.

How does it work?

Bind shell: A bind shell can be opened for the specified port. After open a port, attackers can connect target using programs like netcat. When connection is established, attackers can send any powershell command to the target host. It works till attacker close the session.

Reverse shell: A reverse shell can be openedn for the specified port and ip address. First of all, attacker should listen a port in its machine. After that, a reverse shell can be oopened for the attacker's port and ip address. Again attacker can execute any command as he wish.

