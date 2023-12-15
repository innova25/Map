package org.example.process;

import org.example.model.Vertical;

import java.util.List;

public class WindingNumberAlgorithm {

    public static int calculateWindingNumber(List<Vertical> outline, Vertical point) {
        int windingNumber = 0;

        for (int i = 0; i < outline.size() - 1; i++) {
            Vertical vi = outline.get(i);
            Vertical vi1 = outline.get(i + 1);

            if (vi.getY() <= point.getY()) {
                if (vi1.getY() > point.getY() && isLeft(vi, vi1, point) > 0) {
                    windingNumber++;
                }
            } else {
                if (vi1.getY() <= point.getY() && isLeft(vi, vi1, point) < 0) {
                    windingNumber--;
                }
            }
        }

        return windingNumber;
    }

    private static double isLeft(Vertical a, Vertical b, Vertical c) {
        return (b.getX() - a.getX()) * (c.getY() - a.getY()) - (c.getX() - a.getX()) * (b.getY() - a.getY());
    }
}
