%% Compare the time with and without the ransfer matrix

% for ind = 0 : 1
% cfg.useTransferMatrix = ind;
% tic
% cfg = bst_duneuro_interface(cfg);
% endTime = toc; 
% if ind == 0
%     cfg.timeDuneuroProcess_forward = endTime;
% end
% if ind == 1
%     cfg.timeDuneuroProcess_transfer = endTime;
% end
% end

load('configurationFile','cfg');
% relative error between two solutions :
relativeError = (abs((cfg.lf_fem_direct - cfg.lf_fem_transfer)./cfg.lf_fem_direct));
figure; 
plot (zscore(sum(cfg.lf_fem_direct)), 'ro','markersize',12); hold on; xlabel('Electrode'); ylabel('mean LF')
plot (zscore(sum(cfg.lf_fem_transfer)), 'k*','markersize',12); grid on; grid minor; 
legend('direct','transfer')

figure;
subplot(2,2,1);imagesc(cfg.lf_fem_direct); colorbar; title('direct'); xlabel('electrode'); ylabel('source')
subplot(2,2,2);imagesc(cfg.lf_fem_transfer); colorbar;title('transfer'); xlabel('electrode'); ylabel('source')
subplot(2,2,[3 4]);imagesc(relativeError);title('Relative Error'); xlabel('electrode'); ylabel('source')

cfg.lf_fem_transfer(1,:)

(cfg.lf_fem_direct - cfg.lf_fem_transfer) 