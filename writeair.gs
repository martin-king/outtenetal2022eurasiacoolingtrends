function writetemp

'reset'
'set z 1'

t=1
tmax=72

'set t 1 'tmax
* following mori et al. 'ceu=aave(air,lon=60,lon=120,lat=40,lat=60)'
'ceu=aave(t2m,lon=45,lon=110,lat=40,lat=60)'

while (t<=tmax)
say t
'set t 't
line=sublin(result,1)
date=subwrd(line,4)
year=substr(date,1,4)
month=substr(date,6,1)

'd ceu-273.15'
line=sublin(result,1)
val=subwrd(line,4)

cad=year'  'month'  'val
rc=write('ceu_t2m_djf_era5.txt',cad,append)
t=t+1

endwhile 

return
