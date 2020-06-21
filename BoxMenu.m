function [answer] = BoxMenu (title, question) % opt1, opt2, opt3)

% Function that create a BoxMenu with these 3 options
% Enjoy :)



% Construct a questdlg with three options
choice = questdlg(question, ...
	title, ...
	'Yes','No','Cancel', 'fix');
% Handle response
switch choice
    case 'Yes'
        disp([choice ' chosen.'])
        answer = 1;
    case 'No'
        disp([choice ' chosen.'])
        answer = 2;
    case 'Cancel'
        disp([choice ' chosen.'])
        answer = 0;
end