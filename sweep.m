mulist=0:.1:2;
store=zeros(length(mulist),50);
for i=1:length(mulist)
    mu=mulist(i);
    store(i,:)=spec(mu,.2,2);
end