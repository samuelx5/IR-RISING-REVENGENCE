f=dir('*.png');
fil={f.name};  
for k=1:numel(fil)
  file=fil{k};
  new_file=strrep(strcat('K',file),'.png','.jpg');
  im=imread(file);
  imwrite(im,new_file);
end