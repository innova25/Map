package com.example.demo;

import java.io.*;
import java.util.List;

import com.example.demo.model.Input;
import com.example.demo.model.Vertical;
import com.example.demo.process.Algorithm;
import com.example.demo.process.DataProcess;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/DataServlet")
public class HelloServlet extends HttpServlet {
    public void init() {
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String clientData = request.getParameter("clientData"); //timhieu them
        DataProcess dataProcess = new DataProcess();
        String[] fromClient = clientData.split("\\|");
        String[] start = fromClient[0].split(",");
        String[] end = fromClient[1].split(",");
        StringBuilder outPut= new StringBuilder();
        Algorithm algorithm = new Algorithm(dataProcess, new Input(new Vertical(Double.parseDouble(start[0]), Double.parseDouble(start[1])), new Vertical(Double.parseDouble(end[0]), Double.parseDouble(end[1]))));
        for(Vertical vertical:algorithm.solve()){
            outPut.append(vertical.getX()).append(",").append(vertical.getX()).append("|");
        }
        outPut = new StringBuilder(outPut.substring(0, outPut.length() - 1));
    }

    public void destroy() {
    }
}