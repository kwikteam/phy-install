pushd ~
(new-object System.Net.WebClient).DownloadFile('https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe', "$Home\miniconda3.exe")
.\miniconda3.exe /RegisterPython=1 /S /D="$Home\miniconda3" | Out-Null
$env:Path += ";$Home\miniconda3\;$Home\miniconda3\Scripts"
conda config --set ssl_verify false
conda env create python=3.5 -y
source activate phy
conda install -c kwikteam klustakwik2 -y
conda config --set ssl_verify true
pip install -e .
popd
