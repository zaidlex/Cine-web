<%-- 
    Document   : Compra
    Created on : Dec 17, 2021, 10:46:28 AM
    Author     : zchx
--%>
<%@taglib prefix="TagMain" uri="/WEB-INF/tlds/TagsUtils" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Boostrap  -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
        <title>Compra completada</title>
        <style>
            #body {
                background-color: #0E33FF;
            }
        </style>
    </head>
    <body>
        <%
            String id = request.getParameter("id");
            String sala = request.getParameter("sala");
            String horario = request.getParameter("horario");
            ArrayList<String> asientos = new ArrayList<String>();
            
            /*obteniendo los asientos*/
            Enumeration<String> enumeration = request.getParameterNames();
            while (enumeration.hasMoreElements()) {
                String parameterName = enumeration.nextElement();
                if (parameterName.charAt(0) == 'a'){
                    asientos.add(parameterName.substring(1));
                }
            }
            
            //Inserta los asientos en la base de datos
            Class.forName("com.mysql.jdbc.Driver");
            //String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=UsrCine&password=c!n3#8732";
            String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=zchx&password=lexx";

            java.sql.Connection Connector = null;
            java.sql.Statement Stm = null;
            java.sql.ResultSet Rst = null;
            int RstUd;
            
            String query;
            String idSala = "";
            try{
                Connector = DriverManager.getConnection(ConexionBDD);
                Stm = Connector.createStatement();
                
                query = "SELECT * FROM getIdSala WHERE IDPelicula = "+id+" AND Nombre_Sala = '"+sala+"' AND Hora = TIME('"+horario+"') LIMIT 1";
                Rst = Stm.executeQuery(query);
                if(Rst.next())
                    idSala = Rst.getString("IDSala");
                    
                
                for (int i=0;i<asientos.size();i++) {
                    query = "INSERT INTO Silla (IDSala, Letra, Numero) VALUES ("+idSala+", '"+asientos.get(i).substring(0,1)+"','"+asientos.get(i).substring(1)+"')";
                    RstUd = Stm.executeUpdate(query);
                    if( RstUd == 0)
                        out.println("Error al comprar el asiento"+asientos.get(i));
                }
                
            }catch(SQLException err){
                    out.println("Error: " + err.getMessage()+"\n");
            }finally{
                if (Rst != null)
                    Rst.close();

                if (Stm != null)
                    Stm.close();

                if (Connector != null)
                    Connector.close();
            }
        %>
        <TagMain:tagHomeBar/>
        <table class="table center table-success table-striped">
            <tr><!-- Informacion de la pelicula-->
                <TagMain:InformacionPelicula id="<%=id%>"/>
            </tr>
            <tr>
                <td>
                    <label> <strong> Sala: </strong ><%= sala %></label>
                </td>
                <td>
                    <label> <strong> Horario: </strong ><%= horario %></label>
                </td>
            </tr>
            <tr>
                <td>Asientos comprados:</td>
                <td>
                    <% 
                    for (int i=0;i<asientos.size();i++) {
                        out.println(asientos.get(i));
                    }%>
                </td>
            </tr>
            <tr>
                <td colspan="2"><input type="button" class="btn btn-success" onclick="location.href='index.jsp';" value="Ir a cartelera" /></td>
            </tr>
        </table>
    </body>
</html>
