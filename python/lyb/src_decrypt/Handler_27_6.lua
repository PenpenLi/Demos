Handler_27_6 = class(Command);

function Handler_27_6:execute()
  print(".27.6.",recvTable["MemberArray"],recvTable["Count"],recvTable["BooleanValue"]);
  for k,v in pairs(recvTable["MemberArray"]) do
    print(".27.6..");
    for k_,v_ in pairs(v) do
      print(k_,v_);
    end
  end

  local data = {};
  data.MemberArray=recvTable["MemberArray"];
  data.Count=recvTable["Count"];
  data.BooleanValue=recvTable["BooleanValue"];
  
  if BangpaiMediator then
    local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
    if bangpaiMediator then
      bangpaiMediator:getViewComponent():refreshFamilyMemberIncrease(data);
    end
  end
end

Handler_27_6.new():execute();