/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/TagHandler.java to edit this template
 */
package TagsUtils;

import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.tagext.JspFragment;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;

/**
 *
 * @author zchx
 */
public class tagHome extends SimpleTagSupport {

    /**
     * Called by the container to invoke this tag.The implementation of this
 method is provided by the tag library developer, and handles all tag
 processing, body iteration, etc.
     */
    //@Override
    public void doTag() throws JspException {
        JspWriter out = getJspContext().getOut();
        
        try {
            out.println("<div id=\"homebar\" class=\"contaiclass=\"container-xxl d-flex align-items-md-center\" ner-xxl d-flex align-items-md-center\">");
            out.println("<a href=\"index.jsp\"><h4>Cartelera</h4></a>");
            out.println("</div>");
            out.println("<style>\n" +
                        "    #homebar {\n" +
                        "        background-color: #7EF7CD;\n" +
                        "    }\n" +
                        "</style>");            

            JspFragment f = getJspBody();
            if (f != null) {
                f.invoke(out);
            }
        } catch (java.io.IOException ex) {
            throw new JspException("Error in tagHome tag", ex);
        }
    }
    
}
