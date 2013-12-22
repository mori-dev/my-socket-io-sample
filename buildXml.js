module.exports = function buildXML(rootObj, rootName) {
    var xml = '<?xml version="1.0" encoding="UTF-8"?>\n';
    rootName = rootName || 'xml';
    xml += '<' + rootName + '>\n';
    (function traverse (obj) {
        Object.keys(obj).forEach(function (key) {
            var open = '<' + key + '>\n';
            var close = '</' + key + '>\n';
            var isTxt = (obj[key] && {}.toString.call(obj[key]) !== '[object Object]');

            xml += open;

            if(isTxt) {
                xml += obj[key];
                xml += close;
                return;
            }

            xml += '\n';
            traverse (obj[key]);
            xml += close;

        });
    }(rootObj));

    xml += '</' + rootName + '>\n';
    return xml;
}
