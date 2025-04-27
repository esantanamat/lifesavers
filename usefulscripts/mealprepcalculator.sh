echo "What's the total amount in grams?"
read weight
defaultresult=$((weight/ 4))
echo "How many grams per serving (check your macros)? Default: 4 servings, $defaultresult per serving"
read servingsize
result=$(( weight / servingsize))
echo "This gives you about $result servings for this meal prep"
if [ "$result" -gt 4 ]; then
echo "This exceeds the recommend amount of meal prep days (4), consider cooking less next time"
fi
echo "Weights as you serve:"
counter=0
while [ "$weight" -gt 0 ] && [ "$counter" -lt 4 ]; do
weight=$((weight - servingsize))
counter=$(( counter + 1 ))
if [ "$weight" -lt 0 ]; then
echo "$((weight + servingsize)) left as excess (storage)" 
break
fi
echo "After serving $counter: $weight g"
done

if [ $weight -gt 0 ]; then
echo "$weight g for storage"
fi