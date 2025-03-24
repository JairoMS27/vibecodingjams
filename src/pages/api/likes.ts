import type { APIRoute } from 'astro';
import { db } from '../../lib/db';

export const POST: APIRoute = async ({ request }) => {
  try {
    // Captura el cuerpo de la solicitud como texto primero
    const bodyText = await request.text();

    // Verifica si el cuerpo está vacío
    if (!bodyText || bodyText.trim() === '') {
      return new Response(
        JSON.stringify({ error: 'Empty request body' }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    // Intenta analizar el JSON
    let body;
    try {
      body = JSON.parse(bodyText);
    } catch (parseError) {
      return new Response(
        JSON.stringify({ 
          error: 'Invalid JSON in request body',
          details: parseError instanceof Error ? parseError.message : 'Unknown parse error'
        }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    if (!body?.projectId) {
      return new Response(
        JSON.stringify({ error: 'Missing projectId' }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    const result = await db.toggleLike(body.projectId);

    return new Response(
      JSON.stringify(result),
      { 
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  } catch (error) {
    console.error('Error handling like:', error);
    return new Response(
      JSON.stringify({ 
        error: 'Failed to update like',
        details: error instanceof Error ? error.message : 'Unknown error'
      }),
      { 
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }
};
