
#!/bin/bash
echo "WEB Server Lor Report" > report.txt
echo "=====================">> report.txt
count=0
while read  y
do
	if [ ! -z "$y" ];then
		count=$((count+1))
	else
		exit 1
	fi
done < access.log 
echo "Total number of requests: $count" >> report.txt
awk '
{
	if (seen[$1]++)
	{
		#print "Duplicate:",$1
	}

	else
	{
		original[$1] = $1
	}
}
END {
	count1=length(original)
	print "Nomber of Unique IP Adresses:",count1
}

' access.log >> report.txt
echo "=======" >> report.txt
awk '
{

	if  ($6 ~ /GET/)
	{
		count_Get=count_Get+1
	}

	else if ($6 ~ /POST/)
	{
		count_POST++
	}
}

END {
	print "Number of requests by method"
	print "Get:", count_Get
	print "Post:", count_POST

}

' access.log >> report.txt
awk '
{
	count[$7]++

}
END {
	max_count=0
	for (line in count)
		{
			if (count[line]>max_count)
				{
					max_count=count[line]
					max_stroke=line
				}
		}
	print "Most popular URL:",max_count,max_stroke
}

' access.log >> report.txt
