%% Test PCA EIGENFACES for mood
% TestMoodPCA in order to identify your "mood" from a new snap using
%       PCA Eigenfaces

% Uncomment to do this test apart
% clc
% clear
% close all

%% WebCam setup
% This is commented because it was chosen at GUI_Menu
%     1 para la webCam normal
%     2 para la webCam de mi tablet
%             CamType=1;


%% See if its necessary to do new snaps

 Snap_folder =0;
 % Init mood labels
    mood6 = {'Happy', 'Bored', 'Crazy', 'Angry', 'Sleepy', 'Sad'};
    mood9 = {'Happy', 'Bored', 'Crazy', 'Angry', 'Sleepy', 'Sad', 'Smart' , 'Thankful' , 'Weird'};

 answer1 = BoxMenu ('Menu', 'Do you want new snaps?');
            
        if answer1 == 1  
            choice = questdlg('Number of New Photos?', ...
        'New Snap Mood Pool','6','9', 'fix');
        % Handle response
            switch choice
                case '6'
                    disp([choice ' snaps chosen!'])
                    M = 6;
                case '9'
                    disp([choice ' snaps chosen'])
                    M = 9;
            end
%             mkdir('PCATest/NewPool');
            rmdir('PCAMood/NewPool','s');
            mkdir('PCAMood/NewPool');
            Snap_folder = 'PCAMood/NewPool';
            
            if M == 6
                Img.mood = mood6;
            elseif M == 9
                Img.mood = mood9;
            end

            for i=1:M
               uiwait(msgbox({'Let`s' Img.mood{i} 'snap'}, 'Be Smart plz','warn','modal')); 
               [~, IFaces, bboxes] = Snapshot (CamType);
               I = HOGFeatures(IFaces,bboxes);
               I=ReSize(I);
               imwrite(I,['Foto_', num2str(i),'.jpg']);
               movefile(strcat('Foto_', num2str(i),'.jpg'),Snap_folder);
                
            end
        end
        
        
        if answer1 == 2
            rmdir('PCAMood/NewPool','s');
            mkdir('PCAMood/NewPool');
            % Snaps should be at "PCAMood/Pool"
            uiwait(msgbox('Hope your mood pool be at "PCAMood/Pool" ', 'WARNING','warn','modal'));
            folder_name = uigetdir('PCAMood/Pool','choose pool folder');
            Snap_folder = 'PCAMood/NewPool';
        end
        
        
%   Se sale del programa        
        if answer1 == 0
           GUI_Menu
           return; 
        end
        
        close all

%% Create the imageSet and copying 

 if answer1 == 2
        MeDatabase = imageSet(folder_name,'recursive');
        % Convertimos todas las fotos al mismo tama�o y creamos una copia en el
        % directorio que se ha elegido
        for i=1:MeDatabase.Count
            % Lectura de la imagen
            I = read(MeDatabase(1),i);
            I = ReSize (I);
            imwrite(I,['Foto_', num2str(i),'.jpg']);
            movefile(strcat('Foto_', num2str(i),'.jpg'),Snap_folder);
        end
 end         
        
%% Show a montage of the training photos
FaceDatabase = imageSet(Snap_folder, 'recursive');
figure;
montage(FaceDatabase.ImageLocation);
title('Images of YOUR mood ^^');

%% Star PCA features

% TrainingPCA = imageSet('PCATest/Training','recursive');
dim= size(read(FaceDatabase(1),1),1); % 224  ; % image size
M=FaceDatabase.Count; %9 o 6;        % number faces
            
            % If not new snaps
            if M == 6
                Img.mood = mood6;
            elseif M == 9
                Img.mood = mood9;
            end
            
for i=1:M
    
    Img.data{i} = read(FaceDatabase(1),i); %Creating an structure with pixel data

end
save classFile Img;



% Beggining
% clc
% clear
% close all
load classFile;
% ScreenSize to plot
scrsz = get(0,'ScreenSize');    
ancho = scrsz(3);               
alto = scrsz (4);
ancho = round (ancho/3);
alto = round (alto/2)-40;




% TrainingPCA = imageSet('PCATest','recursive');
num=FaceDatabase.Count;
dim=size(read(FaceDatabase(1),1),1);
   
    
if num==9
    z= [ Img.data{1}  Img.data{2}    Img.data{3}; Img.data{4}     Img.data{5}  Img.data{6};...
        Img.data{7} Img.data{8} Img.data{9}];
    
end

if num==6
    z= [ Img.data{1}  Img.data{2}    Img.data{3}; Img.data{4}     Img.data{5}  Img.data{6}];
 


%% Compute Mean
averageImg=zeros(dim);
for i=1:num
    Img.data{i} = im2single(Img.data{i});
    averageImg   = averageImg  + (1/num)*Img.data{i};
end


%% Normalize (removing mean)
for i=1:num
    Img.dataAvg{i}  = Img.data{i} -averageImg;
end

if num == 9
    z  = [ Img.dataAvg{1}  Img.dataAvg{2}   Img.dataAvg{3}  ; Img.dataAvg{4}     Img.dataAvg{5}  Img.dataAvg{6};...
        Img.dataAvg{7}     Img.dataAvg{8}  Img.dataAvg{9}];

end

if num == 6
    z  = [ Img.dataAvg{1}  Img.dataAvg{2}   Img.dataAvg{3}  ; Img.dataAvg{4}     Img.dataAvg{5}  Img.dataAvg{6}];
    
end

%% Calc Eigenvectors

A = zeros(dim*dim,num);% (N*N)*num   2500*4
for i=1:num
    A(:,i) = Img.dataAvg{i}(:);
end
% Covariance matrix small dimension (transposed)
Cov_mat = A'*A;

%% Eigenvectros  in small dimension
[ Eigvec_V, Eigval_D ]  = eig(Cov_mat);% v num*num e num*num only diagonal 4 eigen values
% eigan face in large dimension  A*Eigvec_V is eigen vector of Clarge
Large_V = A*Eigvec_V;% 2500*num*num*num  =2500 *num
% reshape to eigen face
Eigenfaces=[];
for i=1:num
    c_arr  = Large_V(:,i);
    Eigenfaces{i} = reshape(c_arr,dim,dim);
end
diag_eigval=diag(Eigval_D);
[xc,xci]=sort(diag_eigval,'descend');% largest eigenval

if num == 6
    z  = [ Eigenfaces{xci(1)}  Eigenfaces{xci(2)}   Eigenfaces{xci(3)} ; Eigenfaces{xci(4)}     Eigenfaces{xci(5)}   Eigenfaces{xci(6)}];
    %     Uncommen to show the figure
%     figure(5),imshow(z,'Initialmagnification','fit');title('Eigenfaces')
end

if num == 9
    z  = [ Eigenfaces{xci(1)}  Eigenfaces{xci(2)}   Eigenfaces{xci(3)} ; Eigenfaces{xci(4)}     Eigenfaces{xci(5)}   Eigenfaces{xci(6)};...
       Eigenfaces{xci(7)}  Eigenfaces{xci(8)}   Eigenfaces{xci(9)} ];
    
end
%% Weights
nsel=M% select  eigen faces
for img_num=1:num  % image number
  for i=1:nsel   % eigen face for coeff number
    img_weight(img_num,i) =   sum(A(:,img_num).* Eigenfaces{xci(i)}(:)) ;
  end
end

%% Classify new IMG  

NotFinished = false;

while ~NotFinished 
    close (GUI_MoodPCA)
    answer2 = BoxMenu ('Let�s trying to find Yourself','Let''s take a new picture to compare?');

        switch answer2
            case 1
              [I, IFaces, bboxes] = Snapshot (CamType);
              Icrop = HOGFeatures (IFaces, bboxes);
              testFace = Icrop;
            case 2
               uiwait(msgbox('Then, choose one to compare :)', 'He he he','warn','modal'));
               [file, location] = uigetfile ('*jpg') ;
               I = imread(strcat(location,file));
               % Image proccesing
               faceDetector = vision.CascadeObjectDetector;
               bboxes = step(faceDetector, I);
               IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
               Icrop = HOGFeatures(IFaces,bboxes);
               testFace = Icrop;
               
            case 0
              close all
              uiwait(msgbox('Bye byeeeeee', 'Haleluyaaa','warn','modal'));
              close (GUI_MoodPCA)
              GUI_Menu
              return;  
                
        end 

testFace = imresize(testFace,[dim dim]);
testFace   =  im2single(testFace);
% uncommen to show the figure
% figure(6), imshow(testFace,'Initialmagnification','fit'); title('Test Face')
Average_face = testFace(:)-averageImg(:); % normilized face
for(i=1:nsel)
  face_weight(i)  =  sum(Average_face.* Eigenfaces{xci(i)}(:)) ;
end

% compute distance
for img_num=1:num  
    face_sumcur=0;
    for(i=1:nsel)
        face_sumcur = face_sumcur + (face_weight(i) -img_weight(img_num,i)).^2;
    end
    diffWeights(img_num) =   sqrt( face_sumcur);
end
%    Commen to show all figures
    close all
    [val in]=min(diffWeights);
    diffWeights  =diffWeights.';
    [min2, pos] = sort(diffWeights(:));
    val2 = min2(2);
    in2 = pos(2);
    diff2 = val2 - val;

% Load EmojiDatabase
 EmojiDatabase = imageSet('Emojis','recursive');
	for i=1:EmojiDatabase.Count
        Img.emoji{i} = read(EmojiDatabase(1),i);
    end


run GUI_MoodPCA.m

pause (10)







% figure('Position', [2*ancho 10 ancho alto]), imshow(Img.data{in}),title(['You are THIS ONE']);
end