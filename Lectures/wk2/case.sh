case "$file" in
*.c)  echo "$file looks like a C source-code file" ;;
*.h)  echo "$file looks like a C header file" ;;
*.o)  echo "$file looks like a an object file" ;;
?) echo "$file's name is too short to classify it" ;;
*) echo "I have no idea what $file is" ;;

esac