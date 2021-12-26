<%-- 
    Document   : SeleccionAsiento.jsp
    Created on : Dec 14, 2021, 11:22:57 AM
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
        <title>Selecciona tu asiento</title>
        <style> 
        td {
            text-align: center;
        }
        tr {
            text-align: center;
        }
        </style>
        <script>
        function reservar(btn){
            var asiento = document.getElementById(btn);
            if (asiento.className === "btn btn-light") {
                asiento.className = "btn btn-primary";
                ele = document.createElement('input'); 
                ele.type = 'hidden'; 
                ele.id = asiento.value;
                ele.name = "a"+asiento.value;
                ele.value = asiento.value; 
                document.getElementById('asientos').appendChild(ele);
            }
            else{
                asiento.className = "btn btn-light";
                document.getElementById(asiento.value).remove();
            }
        }
        </script>
        <style>
            #body {
                background-color: #0E33FF;
            }
        </style>
    </head>
    <body id="body">
        <TagMain:tagHomeBar/>
        <%
        String id = request.getParameter("id");
        String [] items = request.getParameter("horariolist").split("\\s*,\\s*");
        String sala = items[0];
        String horario = items[1];
        out.println("</th>"); 
        %>
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
            
            <form id="asientos" action="Compra.jsp" method="POST">
            <div >
                <input type="hidden" name="id" value="<%=id%>">
                <input type="hidden" name="sala" value="<%=sala%>">
                <input type="hidden" name="horario" value="<%=horario%>">
            </div>
            <tr><!--seleccion de asientos-->
            <tr class="center">
                <td colspan="2" style = "background-color:#000000;">
                    <h2><span style="color:white" >Pantalla</span></h2>>
                </td>
            </tr>
            <table class="table table-dark table-borderless">
                
                <%
                    ArrayList<String> asientos = new ArrayList<String>();
                    Class.forName("com.mysql.jdbc.Driver");
                    //String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=UsrCine&password=c!n3#8732";
                    String ConexionBDD = "jdbc:mysql://localhost:3306/Cine?user=zchx&password=lexx";

                    java.sql.Connection Connector = null;
                    java.sql.Statement Stm = null;
                    java.sql.ResultSet Rst = null;
                    String query;
                    String idSala = "";
                    
                    try{
                        Connector = DriverManager.getConnection(ConexionBDD);
                        Stm = Connector.createStatement();
                        
                        query = "SELECT * FROM getIdSala WHERE IDPelicula = "+id+" AND Nombre_Sala = '"+sala+"' AND Hora = TIME('"+horario+"') LIMIT 1";
                        Rst = Stm.executeQuery(query);
                        if(Rst.next())
                            idSala = Rst.getString("IDSala");

                        query = "SELECT * FROM SillasOcupadas WHERE IDSala = "+idSala;
                        Rst = Stm.executeQuery(query);
                        //agrega los asientos ocupados a una lista
                        while(Rst.next()){
                            asientos.add(Rst.getString("Letra")+Rst.getString("Numero"));
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
                    
                    char[] silla_letra = {'A','B','C','D','E','F','G','H','I','J','K'}; //fila
                    int[] silla_numero = {1,2,3,4,5,6,7,8,9,10,11}; //columna
                    int k, l, num_Etq;
                    //Etiquetas de los numeros y letras de la cuadricula
                    out.println("<tr>");
                    for (num_Etq=0; num_Etq< 12; num_Etq++){
                        out.println("<th class=\"table-info\">");
                        if(num_Etq==0){
                            out.println("<label >*</label>");
                        }else{
                            out.println("<label >"+String.valueOf(silla_numero[num_Etq-1]) +"</label>");
                        }
                        out.println("</th>");
                    }
                    out.println("</tr>");
                    //Cuadricula de los asientos
                    for (k=0; k< 11; k++){//columna
                        out.println("<tr>");
                        for (l=0; l< 12; l++){//fila
                            if(l==0){//Si es la primera columna agrega la letra
                                out.println("<th class=\"table-info\">");
                                out.println("<label >"+silla_letra[k]+"</label>");
                            }else{
                                out.println("<th>");
                                //verifica si esta ocupado en la lista
                                if(asientos.contains(silla_letra[k]+String.valueOf(silla_numero[l-1]))){
                                    //Elimina la funcion onclick y lo pone de color rojo
                                    out.println("<input type=\"button\" "
                                    + "class=\"btn btn-danger\""
                                    + "value=\""+silla_letra[k]+String.valueOf(silla_numero[l-1]) +"\">");
                                    asientos.remove(silla_letra[k]+String.valueOf(silla_numero[l-1]));
                                }else{    
                                    out.println("<input type=\"button\" id=\"silla"+silla_letra[k]+String.valueOf(silla_numero[l-1])+"\" "
                                    + "class=\"btn btn-light\" onclick=\"reservar(\'silla"+silla_letra[k]+String.valueOf(silla_numero[l-1])+"\')\" "
                                    + "value=\""+silla_letra[k]+String.valueOf(silla_numero[l-1]) +"\">");
                                }   
                            }  
                        }
                        out.println("</tr>");
                    }
                %>
                
            </table>
        </tr>
        <tr class="center">
            <td>
                <input type="submit" class="btn btn-success" value="Comprar asientos">
            </td>
        </tr>
        </form>
    </table>
</body>
</html>
