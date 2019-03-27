function hhh=my_vline(x,in1,label)
if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=my_vline(x(I),linetype,label);
    end
else
g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,in1,'Color',[.8 .8 .8],'LineWidth', 0.2);
    set(h, 'Color',[0.8 0.8 0.8]);
%         xx=get(gca,'xlim');
%         xrange=xx(2)-xx(1);
%         xunit=(x-xx(1))/xrange;
%         if xunit<0.8
%             text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
%         else
%             text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
%         end
%     end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
   
end
hhh=h;
end