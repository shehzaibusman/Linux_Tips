convertxls2csv converts an excel doc in xls format to csv format.

Useage:
    
    convertxls2csv -fw <TabName> -c <OutputFileToCreate>.csv -x <INPUTFILE>.xls


Then view contents of csv file:

cat <FileName>.csv | awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=, '{print $0}' | column -ts,
    
<br>   

> **Ignore any commas inside a cell**

    awk -vFPAT='([^,]*)|("[^"]+")'

> **Delimit the output with string "OutputBetweenFields" with Output Field Separator (OFS)**
 
    -vOFS=OutputBetweenFields  #can be anything
    
> **Print all fields**

    '{print $0}'

> **Note** Changing from $0 to $1,$2 would result in the first field and 2nd fields only, with OutputBetweenFields string in between.
<br>
<br>

> **Displays output in column format. Looks for string OutputBetweenFields as the delimiter.**

    column -ts"OutputBetweenFields"
