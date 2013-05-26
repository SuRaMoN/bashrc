SuRaMoNs bashrc
===============

Install guide
-------------
```bash
cd ~
git clone https://github.com/SuRaMoN/bashrc.git .bash
rm .bashrc
ln -s .bash/rc .bashrc
```
After installing open and close your terminal


Tips-n-tricks
-------------
### Passwordless mysql
```bash
echo "export MYSQL_PWD=<MYSQLPASSWORD>" > .bash/config/mysql_pwd.include
```
This allows you open a mysql session without entering your password

### Git aliases

Add all files, Diff to head, Commit:
```bash
adc
```

Diff to HEAD:
```bash
di
```

Push and pull to remotes (interactivly):
```bash
pus
pul
```

Branch:
```bash
br
```

Author
------
SuRaMoN

* https://github.com/SuRaMoN/
* https://bitbucket.org/SuRaMoN
* https://sourceforge.net/users/suramon
