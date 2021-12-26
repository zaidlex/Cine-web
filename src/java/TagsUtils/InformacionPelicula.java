/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/TagHandler.java to edit this template
 */
package TagsUtils;

import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.tagext.JspFragment;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author zchx
 */
public class InformacionPelicula extends SimpleTagSupport {

    private String id;

    /**
     * Called by the container to invoke this tag. The implementation of this
     * method is provided by the tag library developer, and handles all tag
     * processing, body iteration, etc.
     */
    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
        }
        //String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=UsrCine&password=c!n3#8732";
        String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=zchx&password=lexx";

        Connection Connector = null;
        java.sql.Statement Stm = null;
        java.sql.Statement StmG = null;

        java.sql.ResultSet Rst = null;
        java.sql.ResultSet RstGeneros = null;

        String query;
        String PosterDir = "file://null/";

        try {
            Connector = DriverManager.getConnection(ConexionBDD);
            Stm = Connector.createStatement();
            StmG = Connector.createStatement();

            //Poster de la pelicula
            query = "SELECT Poster_pel FROM Poster WHERE IDPelicula = " + id;
            Rst = Stm.executeQuery(query);

            //obtiene la direccion del poster   
            if (Rst.next()) {
                PosterDir = "Posters/" + Rst.getString("Poster_pel");
            }

            // Datos de la pelicula
            query = "SELECT * FROM PeliculaINFO WHERE IDPelicula = " + id;
            Rst = Stm.executeQuery(query);
            // Genero de la pelicula
            query = "SELECT * FROM PeliculaGENERO WHERE IDPelicula = " + id;
            RstGeneros = StmG.executeQuery(query);

            if (Rst.next()) {
                out.println("<td><img src=\"" + PosterDir + "\" alt=\"" + Rst.getString("Nombre_Pelicula") + "\" width=\"400\" height=\"500\"> </td>\n");
                out.println("<td id=\"info\"> \n");
                out.println("<h2>" + Rst.getString("Nombre_Pelicula") + "</h2><br><br><br>");
                out.println("<span title = \"" + Rst.getString("Descripcion") + "\" style = \"background-color:#33A8FF;\" >" + Rst.getString("Clasificacion") + "</span>");

                while (RstGeneros.next()) {
                    out.println("<span title=\"" + RstGeneros.getString("Descripcion") + "\" style=\"background-color:#C3BABA;\"> " + RstGeneros.getString("genero_pel") + "</span> \n");
                }
                out.println("<span style = \"background-color:#B9F77E;\" >" + Rst.getString("Duracion") + "</span > <br> <br> \n");
                out.println("<label> <strong> Sipnosis:</strong >" + Rst.getString("Sipnosis") + " </label> <br> <br> \n");
                out.println("<label> <strong> Actores:</strong > " + Rst.getString("Actores") + " </label> <br> <br> \n");
                out.println("<label> <strong> Director:</strong > " + Rst.getString("Director") + "</label> <br> <br> \n");
                out.println("<label> <strong> Distribuidora:</strong > " + Rst.getString("Distribuidora") + "</label> <br> \n");

            } else {
                out.println("Error al cargar la información de la película");
                out.println("</td>");
            }

            out.println("</td>");
            out.println("<style> td {text-align: center;}#info{text-align: left;}</style>");

        } catch (SQLException err) {
            out.println("Error: " + err.getMessage() + "\n");
        } finally {
            if (Rst != null) {
                try {
                    Rst.close();
                } catch (SQLException ex) {
                    Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (RstGeneros != null) {
                try {
                    RstGeneros.close();
                } catch (SQLException ex) {
                    Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (Stm != null) {
                try {
                    Stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (StmG != null) {
                try {
                    StmG.close();
                } catch (SQLException ex) {
                    Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (Connector != null) {
                try {
                    Connector.close();
                } catch (SQLException ex) {
                    Logger.getLogger(InformacionPelicula.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public void setId(String id) {
        this.id = id;
    }

}
