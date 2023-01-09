function strRep = bit_string(val)
%BIT_STRING 
%    Takes in a value and returns the bit representation in a string
%    format so that I can easily do bit manipulations


% Variable precision? To determine whether to give 32 or 64 bits
if any(strcmp(class(val),['double','int64']))
    var_len = 64;
elseif any(strcmp(class(val),'int16'))
    var_len = 16;
elseif any(strcmp(class(val),'int8'))
    var_len = 8;
else
    var_len = 32;
end


strRep = num2str(bitget(val,var_len:-1:1));

end

