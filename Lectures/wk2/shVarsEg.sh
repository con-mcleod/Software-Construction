echo "Enter a value for x: "
read x

echo "Enter a value for y: "
read y

echo "the value of x * y is: $(($x * $y))"

#prints values of xy
echo $x $y
#prints value of x and prints y
echo ${x}y
#prints value of x and prints y
echo "$x"y

#print the value of j, or set to 10 if not set
echo ${j-10}

#set the value of j to 33
echo ${j=33}

#print no value if x variable is not set
echo ${x:?No Value}
echo ${y:?No Value}

echo "Enter your first name: "
read firstName
echo "Enter your last name: "
read lastName

fullName="$firstName $lastName"
echo "Your full name is: $fullName"