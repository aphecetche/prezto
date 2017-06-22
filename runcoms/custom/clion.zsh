alienv2clion()
{
    # output env in a form that can be cut and pasted into CLion Run and Debug
    # configuratio UI
    # CAUTION : with tmux the output does not seem to be cut&pasteable directly
    # so you have to pipe it to a file first and then cut and paste the content
    # of that file (e.g. by opening it in TextEdit on Mac)
   alienv printenv $1 | tr ";" "\n" | grep -v export | sed -e 's/[[:space:]]*$//'
}
