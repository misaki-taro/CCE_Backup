%得到3*3的高斯模板
%parameter: sigma
function[mat] = getGaussianMat(sigma)
%     ele1 ele2 ele1
%     ele2 ele3 ele2
%     ele1 ele2 ele1
    mat = zeros(3,3);
    ele1 = (1/(2*pi*sigma^2))*exp(-1/sigma^2);  %四个角
    ele2 = (1/(2*pi*sigma^2))*exp(-1/(2*sigma^2));  %除了四个角和中点
    ele3 = (1/(2*pi*sigma^2));  %中点
%     mat(1,1) = mat(1,3) = mat(3,1) = mat(3,3) = ele1;
%     mat(1,2) = mat(2,1) = mat(2,3) = mat(3,2) = ele2;
%     mat(2,2) = ele3;
    for i=1:3
        for j=1:3
            if (i==1||i==3)&&(j==1||j==3)
                mat(i,j) = ele1;
            else
                mat(i,j) = ele2;
            end
        end
    end
    mat(2,2) = ele3;
    mat = mat/sum(sum(mat,2));
end