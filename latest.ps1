pushd ~
(new-object System.Net.WebClient).DownloadFile('https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe', "$Home\miniconda3.exe")
.\miniconda3.exe /RegisterPython=1 /S /D="$Home\miniconda3" | Out-Null
$env:Path += ";$Home\miniconda3\;$Home\miniconda3\Scripts"
conda install conda python=3 pip numpy matplotlib scipy h5py pyqt ipython-notebook requests vispy six -y
conda install -c https://conda.binstar.org/kwikteam klustakwik2 -y
pip install vispy phy
popd
