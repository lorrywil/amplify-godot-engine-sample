import { useEffect, useState } from 'react';
// import { Schema } from '$amplify/data/resource';
// import { generateClient } from "aws-amplify/data";
import { View, Heading, Table, TableCell, TableBody, TableHead, TableRow } from '@aws-amplify/ui-react';

import { generateClient } from 'aws-amplify/data';
/**
 * @type {import('aws-amplify/data').Client<import('../../amplify/data/resource').Schema>}
 */
const client = generateClient();

const Leaderboard = () => {

  const [leaderboardData, setLeaderboardData] = useState([]);

  const fetchLeaderboard = async () => {
    const { data: leaderboard, errors } = await client.models.Leaderboard.list({});
    var uniqueBestScores = filterLeaderboard(leaderboard);
    setLeaderboardData(uniqueBestScores)
  };

  const filterLeaderboard = (leaderboard) => {
    const uniqueBestScores = {};
    leaderboard.forEach(record => {
      const { username, score } = record;
      if (!uniqueBestScores[username] || score > uniqueBestScores[username].score) {
        uniqueBestScores[username] = record;
      }
    });
    return Object.values(uniqueBestScores);
  }

  useEffect(() => {
    fetchLeaderboard();
  }, [])

  return (
    <View>
      <Heading marginTop={24} level={4}>Leaderboard</Heading>
      <Table marginTop={24} caption="Leaderboard" highlightOnHover={true}>
        <TableHead>
          <TableRow>
            <TableCell as="th">Username</TableCell>
            <TableCell as="th">Score</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {leaderboardData.map((item, index) => (
            <TableRow key={index}>
              <TableCell>{item.username}</TableCell>
              <TableCell>{item.score}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </View>
  )
}

export default Leaderboard;