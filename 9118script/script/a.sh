nomail=0

while [ $# -gt 0 ] 
do
  case $1 in
    -nomail)
      nomail=1
    ;;
    *)
    ;;
  esac
  shift
done

if [ $nomail -eq 1 ]
then
  echo nomail=1
fi

