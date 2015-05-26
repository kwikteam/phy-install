#!/bin/bash

#
# phy-latest install script
#

INSTALL_MINICONDA=1
MINICONDA_PATH=$HOME/miniconda
BASH_RC=$HOME/.bashrc
VENV=''

if [[ -t 0 ]]; then # we're in a terminal!
    BATCH=0
else
    BATCH=1 # running automated
fi

USAGE_MSG='usage:\n

    -b           run install in batch mode (without manual intervention),\n
    -h           print this help message and exit\n
    -s           skip installation of miniconda (just install phy)\n
    -p PREFIX    miniconda install path, defaults to $MINICONDA_PATH
'

printf 'Welcome to the phy installer (by the Kwik Team).\n\n'

while getopts "bhsp:" x; do
    case "$x" in
        h)
            echo -e $USAGE_MSG
            exit 2
            ;;
        b)
            BATCH=1
            ;;
        p)
            MINICONDA_PATH="$OPTARG"
            ;;
        s)
            INSTALL_MINICONDA=0
            ;;
        ?)
            echo "Error: did not recognize option"
            echo -e $USAGE_MSG
            exit 1
            ;;
    esac
done

if [[ $BATCH == 0 ]] # interactive mode
then
    printf 'We strongly recommend the use of miniconda or anaconda by
Continuum Analytics.\n\n'

    printf 'If you wish to use another Python distribution
instead, then please press CTRL+C to cancel this installation, and
manually install the latest versions of the required packages listed
on http://phy.cortexlab.net/.\n\n'

    printf 'If you already have miniconda installed, or are updating from a
previous version of phy, then please type "No" to skip this step.\n\n'

DEFAULT="yes"
    echo -n "Download and install 64-bit Miniconda? [yes|no]
[$DEFAULT] >>> "
    read ans
    if [[ $ans == "" ]]; then
        ans=$DEFAULT
    fi
    if [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") &&
                ($ans != "y") && ($ans != "Y")]]
    then
        echo "
Skipping install of miniconda...
"
        INSTALL_MINICONDA=0
    else
        INSTALL_MINICONDA=1
    fi
fi

if [[ $INSTALL_MINICONDA == 1 ]]; then
    
    if [[ `uname -s` == 'Linux' ]]; then
        if [[ `uname -m` == 'x86_64' ]]; then
            wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
            bash Miniconda3-latest-Linux-x86_64.sh -b -p $MINICONDA_PATH
        else
            wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86.sh
            bash Miniconda3-latest-Linux-x86.sh -b -p $MINICONDA_PATH
        fi
    elif [[ `uname -s` == 'Darwin' ]]; then
        if [[ `uname -m` == 'x86_64' ]]; then
            wget http://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
            bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $MINICONDA_PATH
        else
            echo "32-bit Mac OS is no longer supported. Please install miniconda and phy manually."
        fi
    else
        echo "
Your operating system does not seem to be supported. Please file an issue
on https://github.com/phy/issues
"
exit 1
    fi

    if [ -f $BASH_RC ]; then
        echo "
Prepending PATH=$MINICONDA_PATH/bin to PATH in $BASH_RC
A backup will be made to: ${BASH_RC}-miniconda.bak
"
        cp $BASH_RC ${BASH_RC}-miniconda.bak
    else
        echo "
    Prepending PATH=$MINICONDA_PATH/bin to PATH in
    newly created $BASH_RC"
    fi
    echo "
# added by Miniconda 3.7.0 installer
export PATH=\"$MINICONDA_PATH/bin:\$PATH\"" >>$BASH_RC

export PATH=$MINICONDA_PATH/bin:$PATH

fi # finished installing miniconda

if [[ $BATCH == 0 ]]; then
    printf 'Would you like to create a new Python virtual environment for phy?
If you are planning on running other Python scripts which require
different versions of packages, please supply a name to create an environment.
You will need to activate this venv prior to using phy every time.
'

    echo -n "
Virtual environment name (no spaces) (leave blank for none) [$VENV] >>> "
    read VENV
fi # batch mode

if [[ ($VENV != '') ]]; then # create a venv
    conda create -q -n $VENV python=3.4 --yes
    source activate $VENV
fi # venv creation

# Install all dependencies
conda install pip numpy matplotlib scipy h5py pyqt ipython-notebook requests --yes

# Install VisPy and phy
pip install vispy phy

echo "
Thank you for installing phy!"

if [[ $VENV != '' ]]; then
    echo "Before using phy, you must type \"source activate $VENV\"
to activate the virtual environment in every new terminal you create.
"
fi

echo "You can manually cluster a dataset with \"phy cluster-manual myfile.kwik\"
Launch an IPython Notebook to analyse your data with \"ipython notebook\"
For help and more documentation, visit http://phy.cortexlab.net.
"

echo "Please run \"source ~/.bashrc\" or open a new terminal before running
phy for the first time.
"

exit 0
