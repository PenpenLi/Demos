

function printTab( tab )
	print("\n\n")
  for k,v in pairs(tab) do
    print(	"ConditionID, = ", v.ConditionID, "\n",
"ItemIdArray, = ", v.ItemIdArray, "\n",
"Count,       = ", v.Count,       "\n",
"MaxCount,    = ", v.MaxCount,    "\n",
"BooleanValue = ", v.BooleanValue,"\n",
"Type,        = ", v.Type,        "\n",
"Param1,      = ", v.Param1,      "\n",
"Param2,      = ", v.Param2,      "\n",
"Param3,      = ", v.Param3,      "\n",
"Group        = ", v.Group                 )
  end
  print("\n\n")
end