% SingMpointExtr_2_save.m
% Singular and Minutiae point extraction + auto-save figures for LaTeX

clear all; close all; clc

% -------- SAVE SETTINGS --------
SAVE   = 1;                    % 0 = no saving, 1 = save figures
OUTDIR = 'latex_figs_enhanced';         % output folder
if SAVE, if ~exist(OUTDIR,'dir'), mkdir(OUTDIR); end, end
% helper to save by number & name
savefig_ltx = @(fignum, name) save_for_latex(fignum, fullfile(OUTDIR,name));

% -------- CAPTURE --------------
imo = double(imread('41_4.tif'));        % db2A FVC2000 (500 dpi, 364x256)
imo = imo(3:362,:);                      % 360x256

% -------- ENHANCE (toggle here) --------
%ENHANCE=0;                 % don't do enhancement
ENHANCE=1;              % do enhancement

switch ENHANCE
    case 0
        % NO ENHANCEMENT (keep size consistent with enhanced branch)
        imo = imo(5:356,5:244);          % 352x248
        im  = imo; imd = imo; fig = 50;  % final results figure number
    case 1
        disp('showing intermediate images of the enhancement process');
        % ENHANCEMENT by directional Gaussian filtering (imh = 352x248)
        imh = EnhFprGauss(imo);          % will display Fig 55 (intermediates), 56–57 (filters)
        im  = imh; imd = imh; fig = 51;
        % Save enhancement-related figures if they exist
        if SAVE
            if ishghandle(55), savefig_ltx(55,'fig55_filtered_images'); end
            if ishghandle(56), savefig_ltx(56,'fig56_filter_bank_A');  end
            if ishghandle(57), savefig_ltx(57,'fig57_filter_bank_B');  end
        end
        % Also show + save the enhanced image alone as Fig 10 (used in Ex.3)
        figure(10); imagesc(imh); colormap(gray); axis image off
        title('Enhanced fingerprint (imh)');
        if SAVE, savefig_ltx(10,'fig10_enhanced_only'); end
        disp('enhancement finished, press a button to continue'); pause;
        disp('**************************');
    otherwise
        error('error in the ENHANCE choice');
end

% -------- FEATURE EXTRACTION --------
% Design first order symmetry filters (hyperbolic)
std_h1 = 1.6;
h1     = hyperbol(std_h1);   % 11x11

% Orientation map (gradient, complex)
[i20_0,i11_0,Z0] = orientation_map(im,1.2,2.1);    % s1=1.2; s2=2.1
[Z5,Z4,Z3,Z2,Z1] = scale_pyr_z(Z0);

% ===== Figure 1: Image + direction fields (levels 3 & 4) =====
figure_number=1; figure(figure_number);
subplot(1,3,1); imagesc(im); colormap(gray); axis image off
title('Fingerprint image at level 0');
subplot(1,3,2); quiver(real(Z3),imag(Z3)); axis('ij'); axis image off
title('Direction image (DR), level 3');
subplot(1,3,3); quiver(real(Z4),imag(Z4)); axis('ij'); axis image off
title('Direction image (DR), level 4');
if SAVE, savefig_ltx(figure_number,'fig01_image_DR_L3_L4'); end
disp('Observe how singular points appear...'); pause; disp('**************************');

% ===== Figure 2: M-point neighborhood (Z0 vs Z3) =====
figure_number=figure_number+1; figure(figure_number);
im_mp = marker(im,130,35,'square'); % mark an m-point region
subplot(1,3,1); imagesc(im_mp); colormap(gray); axis image off
title('Fingerprint image, with an m-point indicated');
ZD=Z0(116:136,17:43);
subplot(1,3,2); quiver(real(ZD),imag(ZD)); axis('ij'); axis image off
title('DR at level 0 around m-point');
ZD=Z3(round((116:136)/8),round((17:43)/8));
subplot(1,3,3); quiver(real(ZD),imag(ZD)); axis('ij'); axis image off
title('DR at level 3 around m-point');
if SAVE, savefig_ltx(figure_number,'fig02_mpoint_DR_Z0_vs_Z3'); end
disp('Can you identify the m-point in DR?'); pause; disp('**************************');

% Hyperbolic complex filtering (parabolic symmetry) on Z3..Z0
[r3c,r3d] = hyperbol_2Dfiltering(h1,Z3);
[r2c,r2d] = hyperbol_2Dfiltering(h1,Z2);
[r1c,r1d] = hyperbol_2Dfiltering(h1,Z1);
[r0c,r0d] = hyperbol_2Dfiltering(h1,Z0);

% ===== Figure 3: Core response at level 3 =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off
title('Fingerprint image');
subplot(1,3,2); quiver(real(Z3(6:end-5,6:end-5)),imag(Z3(6:end-5,6:end-5))); axis('ij'); axis image off
title('DR, level 3');
subplot(1,3,3); imagesc(abs(r3c)); colormap(gray); axis image off
title('Core response |r3c|');
if SAVE, savefig_ltx(figure_number,'fig03_core_response_L3'); end

% ===== Figure 4: Delta response at level 3 =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off
title('Fingerprint image');
subplot(1,3,2); quiver(real(Z3(6:end-5,6:end-5)),imag(Z3(6:end-5,6:end-5))); axis('ij'); axis image off
title('DR, level 3');
subplot(1,3,3); imagesc(abs(r3d)); colormap(gray); axis image off
title('Delta response |r3d|');
if SAVE, savefig_ltx(figure_number,'fig04_delta_response_L3'); end
disp('Core/Delta at level 3.'); pause; disp('**************************');

% ---- Coarse-to-fine localization (levels 2 and 1) ----
[r_3c,c_3c,~] = find_ref_point_max(abs(r3c),7);  max_3c = r3c(r_3c,c_3c);
[r_3d,c_3d,~] = find_ref_point_max(abs(r3d),7);  max_3d = r3d(r_3d,c_3d);

% Level 2
nn3 = max_3c/abs(max_3c); new_mva_2c = abs(r2c).*real(r2c.*conj(nn3));
f2=4; w1=40;
[r_2c,c_2c] = find_max_lower_levels_core_dir(new_mva_2c,w1,f2,r_3c,c_3c,nn3);
nn3 = max_3d/abs(max_3d); new_mva_2d = abs(r2d).*real(r2d.*conj(nn3));
w1=6; [r_2d,c_2d] = find_max_lower_levels_hom(new_mva_2d,w1,r_3d,c_3d);

% ===== Figure 5: Level 2 (core) =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off; title('Fingerprint image');
subplot(1,3,2); quiver(real(Z2(6:end-5,6:end-5)),imag(Z2(6:end-5,6:end-5))); axis('ij'); axis image off; title('DR, level 2');
subplot(1,3,3); imagesc(new_mva_2c); colormap(gray); axis image off; title('Core response (L2, sharpened)');
if SAVE, savefig_ltx(figure_number,'fig05_core_L2'); end

% ===== Figure 6: Level 2 (delta) =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off; title('Fingerprint image');
subplot(1,3,2); quiver(real(Z2(6:end-5,6:end-5)),imag(Z2(6:end-5,6:end-5))); axis('ij'); axis image off; title('DR, level 2');
subplot(1,3,3); imagesc(new_mva_2d); colormap(gray); axis image off; title('Delta response (L2, sharpened)');
if SAVE, savefig_ltx(figure_number,'fig06_delta_L2'); end
disp('Level 2 refinement.'); pause; disp('**************************');

% Level 1
nn2 = r2c(r_2c,c_2c); nn2 = nn2/abs(nn2);
new_mva_1c = abs(r1c).*real(r1c.*conj(nn2));
f2=4; w1=60; [r_1c,c_1c] = find_max_lower_levels_core_dir(new_mva_1c,w1,f2,r_2c,c_2c,nn2);

nn2 = r2d(r_2d,c_2d); nn2 = nn2/abs(nn2);
new_mva_1d = abs(r1d).*real(r1d.*conj(nn2));
w1=6; [r_1d,c_1d] = find_max_lower_levels_hom(new_mva_1d,w1,r_2d,c_2d);

% ===== Figure 7: Level 1 (core) =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off; title('Fingerprint image');
subplot(1,3,2); quiver(real(Z1(6:end-5,6:end-5)),imag(Z1(6:end-5,6:end-5))); axis('ij'); axis image off; title('DR, level 1');
subplot(1,3,3); imagesc(new_mva_1c); colormap(gray); axis image off; title('Core response (L1, sharpened)');
if SAVE, savefig_ltx(figure_number,'fig07_core_L1'); end

% ===== Figure 8: Level 1 (delta) =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(im(20:end-19,20:end-19)); colormap(gray); axis image off; title('Fingerprint image');
subplot(1,3,2); quiver(real(Z1(6:end-5,6:end-5)),imag(Z1(6:end-5,6:end-5))); axis('ij'); axis image off; title('DR, level 1');
subplot(1,3,3); imagesc(new_mva_1d); colormap(gray); axis image off; title('Delta response (L1, sharpened)');
if SAVE, savefig_ltx(figure_number,'fig08_delta_L1'); end
disp('Level 1 refinement.'); pause; disp('**************************');

% -------- Minutiae detection (level 0) --------
std1 = std_h1;
gxLS = gaussgen(std1,'gau',[1,2*round(3*std1)+1]);
i20LS = filter2(gxLS',filter2(gxLS,Z0,'valid'),'valid');
i11LS = filter2(gxLS',filter2(gxLS,abs(Z0),'valid'),'valid');
kkLS  = sqrt(mean(mean(abs(Z0))));
LS0   = i20LS./(i11LS+kkLS);
PSi   = r0c.*(1-abs(LS0));
BB    = BinaryMask(Z3,gxLS);
PSi   = PSi.*BB;
howmany = 60;
[LMImage,Rcoord,Ccoord] = SearchMpoints(abs(PSi),howmany);

% ===== Figure 9: Minutiae response and LM =====
figure_number=figure_number+1; figure(figure_number);
subplot(1,3,1); imagesc(imd); colormap(gray); axis image off; title('Fingerprint image');
subplot(1,3,2); imagesc(abs(PSi)); colormap(gray); axis image off; title('|PSi| (level 0)');
subplot(1,3,3); imagesc(LMImage); colormap(gray); axis image off; title('Local maxima (centers)');
if SAVE, savefig_ltx(figure_number,'fig09_minutiae_response_and_LM'); end
disp('Minutiae detection.'); pause; disp('**************************');

% -------- Final overlays (S & M) --------
f2=13;                           % display scaling from level 1 coords
im1=marker(imd,f2+2*r_1c,f2+2*c_1c,'square');  % core (level 1)
im1=marker(im1,f2+2*r_1d,f2+2*c_1d,'plus');    % delta (level 1)
for kk=1:length(Rcoord)
    im2=marker(imd,Rcoord(kk)+9,Ccoord(kk)+9,'circlesmall');
    imd=im2;
end
figure(fig);
subplot(1,2,1); imshow(im1/255); axis on; title('square=corepoint  plus=deltapoint')
subplot(1,2,2); imshow(im2/255); axis on; title('minutia points')

% Save final result as Figure 50/51
if SAVE
    if ENHANCE==0
        savefig_ltx(fig,'fig50_S_and_M_no_enhance');
    else
        savefig_ltx(fig,'fig51_S_and_M_enhanced');
    end
end

% ================= Helper (placed at end of script) ==================
function save_for_latex(fignum, outpath_noext)
% Saves both PDF (vector) and PNG (300 dpi) with tight borders.
try
    fh = figure(fignum);
    drawnow;
    % Ensure tight layout
    set(fh,'Color','w');
    % PDF (vector) for LaTeX includegraphics
    exportgraphics(fh, [outpath_noext '.pdf'], 'ContentType','vector', 'BackgroundColor','white');
    % PNG (bitmap) for quick preview / reports
    exportgraphics(fh, [outpath_noext '.png'], 'Resolution',300, 'BackgroundColor','white');
    fprintf('Saved: %s.[pdf|png]\n', outpath_noext);
catch ME
    warning('Could not save figure %d (%s): %s', fignum, outpath_noext, ME.message);
end
end