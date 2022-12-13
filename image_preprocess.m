
%% section 1
rootdir = 'C:\users\GG\Downloads\all_mask';
rootdir2 = 'C:\users\GG\Downloads\rawPT';
folder = 'C:\users\GG\Downloads\new_mask';
folder2 = 'C:\users\GG\Downloads\new_raw_PET';
filelist = dir(fullfile(rootdir));
filelist2 = dir(fullfile(rootdir2));
img_size = zeros(4,225);
tumor_range = zeros(2,225);
center_slice = zeros(1,225);
patient_num = zeros(1,225);
for n = 1:225
    str = filelist(n+2).name;
    index = strfind(str, '_');
    index2 = strfind(str, '-');
    num = str2num(str(index2+1:index(1)-1));
    patient_num(n) = num;
    filename = ['GT_PET_',sprintf('%d',num),'_all_tumor.mat'];
    filename2 = ['Raw_PET_',sprintf('%d',num),'.mat'];
    load(filelist(n+2).name);
    load(filelist2(n+2).name);
    temp = size(all_tumor_mask);
    if length(temp)<4
        temp = cat(2,temp,1);
        temp2 = sum(all_tumor_mask,[1 2]);
        temp3 = all_tumor_mask;
    else 
        temp2 = sum(all_tumor_mask,[1 2 4]);
        temp3 = sum(all_tumor_mask,4)~=0;
    end
    img_size(:,n) = temp;
    tumor_range(1,n) = max(find(temp2));
    tumor_range(2,n) = min(find(temp2));
    center = round(mean(tumor_range(1,n),tumor_range(2,n)));
    if center <= 48
        signal = all_tumor_mask(:,:,1:96,:);
        pet_img = raw_PT_img(:,:,1:96);
        summed_mask = double(temp3(:,:,1:96));
    else
        signal = all_tumor_mask(:,:,center-48:center+47,:);
        pet_img = raw_PT_img(:,:,center-48:center+47);
        summed_mask = double(temp3(:,:,center-48:center+47));
    end
    background = 1 - signal;
    save(fullfile(folder, filename),'signal','background','summed_mask');
    save(fullfile(folder2, filename2),'pet_img');
    center_slice(n) = center;
    
end


pixel_num = unique(img_size(1,:));
slice_num = unique(img_size(3,:));
max_range = max(tumor_range(1,:)-tumor_range(2,:));
start_slice = min(tumor_range(1,:));
end_slice = max(tumor_range(2,:));
figure();
histogram(tumor_range(1,:)-tumor_range(2,:));

%%
figure();
subplot(2,2,1);
imagesc(pet_img(:,:,49));
subplot(2,2,2);
imagesc(summed_mask(:,:,49));
subplot(2,2,3);
imagesc(all_tumor_mask(:,:,center,1));
subplot(2,2,4);
imagesc(all_tumor_mask(:,:,center,2));




