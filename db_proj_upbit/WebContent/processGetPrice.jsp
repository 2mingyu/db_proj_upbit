<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>

<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@	page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>

<%@ include file="dbconn.jsp"%>
<div class=col>
	<table class="table">
<%
// Upbit api로 가격 불러오기

String sql = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
sql = "select mname from market";
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
while (rs.next()) {
	String cname = rs.getString("mname");
	if (!cname.equals("KRW")) {
		String u = "https://api.upbit.com/v1/ticker?markets=KRW-" + cname;
		try {
			URL url = new URL(u);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			int responseCode = connection.getResponseCode();
			System.out.println(responseCode + u);
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			StringBuffer stringBuffer = new StringBuffer();
			String inputLine;
			while ((inputLine = bufferedReader.readLine()) != null) {
				stringBuffer.append(inputLine);
			}
			bufferedReader.close();
			String rresponse = stringBuffer.toString();

			rresponse = rresponse.replace("[{", "");
			rresponse = rresponse.replace("}]", "");
			rresponse = rresponse.replace(":", " ");
			rresponse = rresponse.replace(",", " ");
			rresponse = rresponse.replace("\"", "");
			//out.println(rresponse);
			String responses[] = rresponse.split(" ");
			for (int i = 0; i < responses.length; i++) {
				if (responses[i].equals("trade_price")) {
					%>
						<tbody>
							<th scope="col"><%=cname %></th>
							<th scope="col"><%=responses[i+1] %></th>
						</tbody>
					<%
					sql = "UPDATE market SET price=? WHERE mname=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setFloat(1, Float.parseFloat(responses[i + 1]));
					pstmt.setString(2, rs.getString("mname"));
					pstmt.executeUpdate();
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
%>
	</table>
</div>