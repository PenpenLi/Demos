Handler_27_11 = class(Command);

function Handler_27_11:execute()
  print(".27.11.",recvTable["FamilyId"],recvTable["FamilyName"],recvTable["MemberArray"],recvTable["Count"],recvTable["FamilyLevel"],recvTable["Ranking"],recvTable["Huoyuedu"]);
  for k,v in pairs(recvTable["MemberArray"]) do
    print(".27.11..");
    for k_,v_ in pairs(v) do
      print(k_,v_);
    end
  end
  uninitializeSmallLoading();

  local familyInfo = {};
  familyInfo.FamilyId=recvTable["FamilyId"];
  familyInfo.FamilyName=recvTable["FamilyName"];
  familyInfo.MemberArray=recvTable["MemberArray"];
  familyInfo.Count=recvTable["Count"];
  familyInfo.FamilyLevel=recvTable["FamilyLevel"];
  familyInfo.Ranking=recvTable["Ranking"];
  familyInfo.Huoyuedu=recvTable["Huoyuedu"];

  if BangpaiMediator then
	  local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	  if bangpaiMediator then
	  	bangpaiMediator:getViewComponent():refreshFamilyInfo(familyInfo);
	  end
	end
end

Handler_27_11.new():execute();