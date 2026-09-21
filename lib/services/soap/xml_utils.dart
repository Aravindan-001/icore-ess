/// Generic XML utility class for SOAP request/response handling.
class XmlUtils {
  /// Extracts the content between specific XML tags.
  /// Used when full DOM parsing is overkill for simple fields.
  static String? getTagContent(String xml, String tag) {
    final startTag = '<$tag>';
    final endTag = '</$tag>';
    
    final startIndex = xml.indexOf(startTag);
    if (startIndex == -1) return null;
    
    final contentStart = startIndex + startTag.length;
    final endIndex = xml.indexOf(endTag, contentStart);
    if (endIndex == -1) return null;
    
    return xml.substring(contentStart, endIndex);
  }

  /// Wraps a value in an XML tag.
  static String wrapTag(String tag, dynamic value) {
    if (value == null) return '<$tag xsi:nil="true" />';
    return '<$tag>$value</$tag>';
  }

  /// Escapes special XML characters.
  static String escape(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Detects if the response contains a SOAP Fault.
  static bool isSoapFault(String xml) {
    return xml.contains('<soap:Fault>') || xml.contains('<Fault>');
  }

  /// Basic check for a successful SOAP response wrapper.
  static bool isSuccessResponse(String xml, String operation) {
    return xml.contains('${operation}Result') || xml.contains('${operation}Response');
  }
}
