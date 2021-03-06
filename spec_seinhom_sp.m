%%for self energy & inhomogenous potential
function [dosmap,rev,dosmat]=spec_seinhom_sp(a,mu,delta,alpha,gamma,vc,dim,smoothpot,mumax,peakpos,sigma,period)
% a=1;
vzlist=linspace(0,2.048,401);
% vzlist=0:0.001:0.95;
% nv=20;
enlist=linspace(-.21,.21,1001);
dosmap=cell(1,length(vzlist));
dosmat=zeros(length(vzlist),length(enlist));
% dosmap2=zeros(length(vzlist),length(enlist));

parfor i=1:length(vzlist)
    vz=vzlist(i);
    disp(i);
    dos=arrayfun(@(w) dosseinhom(a,mu,delta,vz,alpha,gamma,vc,dim,smoothpot,mumax,peakpos,sigma,w,1e-3,period),enlist);
    dosmat(i,:)=dos;
    [~,loc]=findpeaks(dos,'MinPeakHeight',10);
    init=enlist(loc);
%     dosmap2(i,:)=dos;
%     num_init=min(nv,length(init));
%     tmp=init(1:num_init);
%     if num_init<nv
%         tmp=[tmp,zeros(1,nv-num_init)];
%     end    
    dc=delta*sqrt(1-(vz/vc)^2);
    dosmap{i}=init(abs(init)<dc);    
end
rev=vzlist;
fn_mu=strcat('m',num2str(mu));
fn_Delta=strcat('D',num2str(delta));
fn_alpha=strcat('a',num2str(alpha));
fn_wl=strcat('L',num2str(dim));
fn_gamma=strcat('g',num2str(gamma));
fn_vc=strcat('vc',num2str(vc))*(vc~=inf);
fn_smoothpot=num2str(smoothpot);
fn_mumax=strcat('mx',num2str(mumax));
fn_sigma=strcat('sg',num2str(sigma));
if (strcmp(smoothpot,'lorentz')||strcmp(smoothpot,'lorentzsigmoid'))
    fn_peakpos=strcat('pk',num2str(peakpos));
else
    fn_peakpos='';
end


fn=strcat(fn_mu,fn_Delta,fn_alpha,fn_wl,fn_smoothpot,fn_mumax,fn_sigma,fn_peakpos,fn_gamma,fn_vc);
% save(strcat(fn,'.dat'),'dosmap','-ascii');

fid = fopen(strcat(fn,'.dat'),'w');
for i=1:length(vzlist)
    fprintf(fid,'%f ', dosmap{i});
    fprintf(fid,'\n');
end
fclose(fid);

% dosmap(dosmap==0)=nan;

figure;
for i=1:length(vzlist)
    scatter(ones(1,length(dosmap{i}))*vzlist(i),dosmap{i},'b','.');
    hold on
end

box on
hold off
xlabel('V_Z(meV)')
ylabel('V_{bias}(meV)')
axis([0,vzlist(end),-.3,.3])
line([sqrt(mu^2+gamma^2),sqrt(mu^2+gamma^2)],[-0.3,0.3])
saveas(gcf,strcat(fn,'.png'))
end