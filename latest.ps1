pushd ~
(new-object System.Net.WebClient).DownloadFile('https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe', "$Home\miniconda3.exe")
.\miniconda3.exe /RegisterPython=1 /S /D="$Home\miniconda3" | Out-Null
$env:Path += ";$Home\miniconda3\;$Home\miniconda3\Scripts"
conda config --set ssl_verify false
conda install conda python=3.4 pip numpy matplotlib scipy h5py pyqt ipython-notebook requests vispy six -y
conda install -c kwikteam klustakwik2 -y
conda config --set ssl_verify true
pip install vispy phy
popd
