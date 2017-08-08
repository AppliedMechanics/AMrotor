function [J]=jacobian(F_1,F_2,u_1,u_2)

n=length(F_1);

J=zeros(n);

for i=1:n
    for j=1:n
        J(i,j)=(F_2(i)-F_1(i))/(u_2(j)-u_1(j));
    end
end

end