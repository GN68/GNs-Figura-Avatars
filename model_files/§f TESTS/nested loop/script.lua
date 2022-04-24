table = {
    shrek={
        color="green",
        gay=false,
    },
    amongUs={
        sus=true,
        color="red"
    },
    minecraft={
        steve={
            gender=false,
            blocky=true,
            gaming={
                table=true,
                geg={
                    false,
                    true
                }
            }
        },
        alex={
            gender=true,
            who="jeb but blocky",
            race="car",
            numbers={1,2,3,4,5,6,7,8,9,0}
        }
    }
}
TabLevel = 1
function PrintTable(Table)
    
    for Key,Value in pairs(Table) do
        if type(Value) == "table" then
	        TabLevel = TabLevel + 1
	        print(string.rep("    ",TabLevel - 1)..Key.." : {")
            PrintTable(Value)
            print(string.rep("    ",TabLevel - 1).."}")
            TabLevel = TabLevel - 1
        else
            print(string.rep("    ",TabLevel)..Key)
        end
    end
end
PrintTable(table)
