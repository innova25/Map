package org.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Input;
import org.example.model.Vertical;
import org.example.process.AlgorithmName;
import org.example.process.DataProcess;
import org.example.process.OutPut;
import org.example.process.PointInPolygonAlgorithm;

import java.io.IOException;

@WebServlet("/DataServlet")
public class HelloServlet extends HttpServlet {
    DataProcess dataProcess;
    public void init() {
        try {
            dataProcess = new DataProcess();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Retrieve the values of the parameters sent from JavaScript
        String start = request.getParameter("start");
        String end = request.getParameter("end");
        String algorithmName = request.getParameter("algorithm");
        String[] startData = start.split(",");
        String[] endData = end.split(",");
        Input input = new Input(new Vertical(Double.parseDouble(startData[0]),Double.parseDouble(startData[1])),
                new Vertical(Double.parseDouble(endData[0]),Double.parseDouble(endData[1])));
        String result = processData(input, algorithmName);

        response.getWriter().write(result);
    }

    private String processData(Input input, String algorithmName) {
        StringBuilder response = new StringBuilder();
        if(PointInPolygonAlgorithm.isPointInsidePolygon(input.getStart(),dataProcess)&&PointInPolygonAlgorithm.isPointInsidePolygon(input.getEnd(),dataProcess)){
            response.append("true:");
        }else response.append("false:");
        switch (algorithmName){
            case "Dijkstra" -> response.append(OutPut.getResult(input,dataProcess, AlgorithmName.DIJKSTRA));
            case "A*" -> response.append(OutPut.getResult(input,dataProcess, AlgorithmName.A_STAR));
        }

        return response.toString();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        // Process the parameters and generate a response
        StringBuilder outline = new StringBuilder();
        for(Vertical vertical : dataProcess.getOutline()){
            outline.append(vertical.getX()).append(",").append(vertical.getY()).append("|");
        }
        String out = outline.substring(0,outline.length()-1);

        // Send the response back to the client
        response.getWriter().write(out);
    }


    public void destroy() {
    }
}