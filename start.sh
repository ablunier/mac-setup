
#!/bin/bash
# bootstrap script

function uninstall {
    echo "WARNING : This will remove homebrew and all applications installed through it"
    echo -n "are you sure you want to do that? [y/n] : "
    read confirmation

    if [ $confirmation == "y" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
        exit 0
    else
      echo "keeping everything as it is"
      exit 0
    fi
}

if [ $1 == "uninstall" ]; then
    uninstall
fi

echo "-------------------------------------------"
echo "Setting up Mac                             "
echo "-------------------------------------------"

sudo easy_install pip
sudo easy_install ansible

install_dir="/tmp/macsetup-$RANDOM"
mkdir $install_dir

git clone git@github.com:ablunier/mac-setup.git $install_dir 
if [ ! -d $install_dir ]; then
    echo "failed to find mac-setup repository."
    echo "git cloned failed"
    exit 1
else
    cd $install_dir 
    ansible-playbook -i ./hosts playbook.yml --verbose
fi

echo "cleaning up..."

rm -Rfv /tmp/$install_dir

echo "job done!"

exit 0
