<%-- 
    Document   : index
    Created on : Dec 12, 2021, 6:52:20 PM
    Author     : zchx
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@taglib prefix="TagMain" uri="/WEB-INF/tlds/TagsUtils" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Boostrap  -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
        <title>Cine la fie</title>
        <style>td { text-align: center; } tr { text-align: center; } #nombre{ text-align: left; }
            #body {
                background-color: #0E33FF;
            }
        </style>
    </head>
    <body id ="body">
        <TagMain:tagHomeBar/>
        <h1>Cartelera</h1> 
        
        <!--Consulta -->
        <%
        SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date(System.currentTimeMillis());
        String fecha_actual = formatter.format(date).toString();
        Class.forName("com.mysql.jdbc.Driver");
        //String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=UsrCine&password=c!n3#8732";
        String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=zchx&password=lexx";
        
        java.sql.Connection Connector = null;
        java.sql.Statement Stm = null;
        java.sql.ResultSet Rst = null;
        String query;
        
        try{
            Connector = DriverManager.getConnection(ConexionBDD);
            Stm = Connector.createStatement();
            
            query = "SELECT * FROM Cartelera WHERE '"+fecha_actual+"' BETWEEN Extreno AND FinCartelera";
            Rst = Stm.executeQuery(query);
            
            while (Rst.next()) {
        %>
        <table class="table center table-success table-striped">
            <tr>
                <td> <button type="button" class="btn btn-light">
                        <form id ="<%=Rst.getString("IDPelicula")%>" action="pelicula.jsp" method="POST">
                            <input type="hidden" name="id" value="<%=Rst.getString("IDPelicula")%>">
                            <input type="image" src="Posters/<%=Rst.getString("Poster_pel")%>" width="400" height="500">
                        </form>
                    </button></td>
                <td id="nombre"> <a href="javascript:;" onclick="document.getElementById('<%=Rst.getString("IDPelicula")%>').submit();"><h3><%=Rst.getString("Nombre_Pelicula")%></h3></a></td>
            </tr>
        </table>
        <%
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
    </body>
</html>