<%-- 
    Document   : pelicula
    Created on : Dec 13, 2021, 6:50:48 PM
    Author     : zchx
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@taglib prefix="TagMain" uri="/WEB-INF/tlds/TagsUtils" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Boostrap  -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
        <title>Película</title>
        <style>
            #body {
                background-color: #0E33FF;
            }
        </style>
    </head>
    <body id="body">
        <TagMain:tagHomeBar/>
        <%
        //Datos de la pelicula
        String id = request.getParameter("id");

        Class.forName("com.mysql.jdbc.Driver");
        //String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=UsrCine&password=c!n3#8732";
        String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=zchx&password=lexx";

        java.sql.Connection Connector = null;
        java.sql.Statement StmSH = null;
        java.sql.ResultSet RstSH = null;

        String query;
        %>
        <table class="table center table-success table-striped">
            <tr><!-- Informacion de la pelicula-->
                <TagMain:InformacionPelicula id="<%=id%>"/>
            </tr>
            <form action="SeleccionAsiento.jsp" method="POST">
                <input type="hidden" name="id" value="<%=id%>">
                <tr><!-- Selecion de horario -->
                    <td>
                        <p><strong>Horarios disponibles</strong></p>
                        <label for="horario" name="SalaHorario">Escoge tu horario:</label>
                        <select id="horario" name="horariolist">
                            <%
                            try{
                                Connector = DriverManager.getConnection(ConexionBDD);
                                StmSH = Connector.createStatement();
                                query = "SELECT * FROM PeliculaSH WHERE IDPelicula = "+id ;
                                RstSH = StmSH.executeQuery(query);
                                while(RstSH.next()){
                                    out.println("<option value=\""+RstSH.getString("Nombre_Sala")+","+RstSH.getTime("Hora").toString()+"\">"+RstSH.getTime("Hora").toString()+"</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <%
                }catch(SQLException err){
                    out.println("Error: " + err.getMessage()+"\n");
                }finally{
                    if (RstSH != null)
                        RstSH.close();

                    if (StmSH != null)
                        StmSH.close();

                    if (Connector != null)
                        Connector.close();
                }
                %>
                <tr>
                    <td>
                        <input type="submit" class="btn btn-success" value="Comprar">
                    </td>
                </tr>
            </form>
        </table>
    </body>
</html>
