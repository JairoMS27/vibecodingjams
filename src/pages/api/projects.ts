import type { APIRoute } from 'astro';
import { db } from '../../lib/db';

export const GET: APIRoute = async () => {
  try {
    const projects = await db.getProjects();
    
    return new Response(
      JSON.stringify(projects),
      { 
        status: 200,
        headers: { 
          'Content-Type': 'application/json',
          'Cache-Control': 'no-store, no-cache, must-revalidate'
        }
      }
    );
  } catch (error) {
    console.error('Error fetching projects:', error);
    return new Response(
      JSON.stringify({ 
        error: 'Failed to fetch projects',
        details: error instanceof Error ? error.message : 'Unknown error'
      }),
      { 
        status: 500,
        headers: { 
          'Content-Type': 'application/json',
          'Cache-Control': 'no-store, no-cache, must-revalidate'
        }
      }
    );
  }
};