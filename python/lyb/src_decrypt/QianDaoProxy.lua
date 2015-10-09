
QianDaoProxy=class(Proxy);

function QianDaoProxy:ctor()
  self.class=QianDaoProxy;
  -- self.monthqiandao
  -- self.yijinglingqu
  -- self.leijiqiandao
  -- self.shangcilingqu
end

rawset(QianDaoProxy,"name","QianDaoProxy");

--龙骨
function QianDaoProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("qiandao_ui");
  end
  return self.skeleton;
end
function QianDaoProxy:setData(month, monthqiandao,leijiqiandao,booleanvalue)
  self.month = month;
  self.monthqiandao=monthqiandao
  self.yijinglingqu=booleanvalue
  self.leijiqiandao=leijiqiandao
end

function QianDaoProxy:getMonthQianDao()
  return self.monthqiandao
end
function QianDaoProxy:yiJingLingQu()
  return self.yijinglingqu
end
function QianDaoProxy:getLeiJiQianDao()
  return self.leijiqiandao
end
