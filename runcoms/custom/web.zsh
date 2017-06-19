pitchme() 
{
dir=${1:-alo}
cd ~/Sites/gitpitch.com/${dir} || return
/usr/bin/python -m SimpleHTTPServer 8123
}
