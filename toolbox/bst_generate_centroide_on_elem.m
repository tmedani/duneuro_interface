function elem_centroide = bst_generate_centroide_on_elem(node,elem)

% TODO optimize the computation and avoid the loop for.

if 0
    elem_centroide =[];
    tic
    xnode = node(elem(:,1:4),1); xnode1 = reshape(xnode,4,[]);  xmean = mean(xnode1);
    ynode = node(elem(:,1:4),2); ynode1 = reshape(ynode,4,[]);  ymean = mean(ynode1);
    znode = node(elem(:,1:4),3); znode1 = reshape(znode,4,[]);  zmean = mean(znode1);
    t1 = toc;
    elem_centroide = [ xmean' ymean' zmean']
end

if 1
    tic
    elem_centroide = zeros(length(elem),3);
    for indEl = 1 : length(elem)
        elem_centroide(indEl,:) = mean(node(elem(indEl,1:4),:));
    end
    t2 = toc;
end

if 0
figure;plotmesh(node,elem,'x>0','facealpha',0.5);  hold on;plotmesh(elem_centroide,'x>0','r.')
figure;plotmesh(node,elem(1:4,:),'facealpha',0.5);  hold on;plotmesh(elem_centroide(1:4,:),'rx')
end
end